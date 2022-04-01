#!/usr/bin/env zsh

set -e

upload_package() {
  PACKAGE_PATH="${1}"
  UPLOAD_INFO="${2}"

  echo "${UPLOAD_INFO}" | jq
  UPLOAD_URL=$(echo "${UPLOAD_INFO}" | jq -r '.upload.url')
  UPLOAD_ARN=$(echo "${UPLOAD_INFO}" | jq -r '.upload.arn')
  curl -T "${PACKAGE_PATH}" "${UPLOAD_URL}"

  while true; do
    UPLOAD_RESULT=$(aws devicefarm get-upload --arn "${UPLOAD_ARN}")
    UPLOAD_STATUS=$(echo "${UPLOAD_RESULT}" | jq -r '.upload.status')

    if [ "${UPLOAD_STATUS}" = "FAILED" ]; then
      echo "Upload did not complete successfully, the status was ${UPLOAD_STATUS}"
      echo "Unable to proceed with the tests"
      exit 1
    elif [ "${UPLOAD_STATUS}" != "SUCCEEDED" ]; then
      echo "Upload of ${PACKAGE_PATH} is not completed, current status is ${UPLOAD_STATUS}"
      echo "Wait until upload is completed ..."
      sleep 5
    else
      echo "Uploading ${PACKAGE_PATH} is completed with status ${UPLOAD_STATUS}"
      break
    fi
  done
}

wait_for_test_results() {
  SCHEDULED_TEST_RUN="${1}"
  TEST_RUN_ARN=$(echo "${SCHEDULED_TEST_RUN}" | jq -r '.run.arn')
  echo "${SCHEDULED_TEST_RUN}" | jq

  while true;
  do
    TEST_RUN=$(aws devicefarm get-run --arn "${TEST_RUN_ARN}")
    TEST_RUN_STATUS=$(echo "$TEST_RUN" | jq -r '.run.status')
    if [ "${TEST_RUN_STATUS}" != "COMPLETED" ]; then
      echo "Test run is not completed, current status is ${TEST_RUN_STATUS}"
      sleep 30
    else
      break
    fi
  done

  echo "${TEST_RUN}" | jq
  echo "${TEST_RUN}" > test-result.json
  echo "Test run completed, saving result to test-result.json"
}

# Upload Your Application File
echo "Upload ${AWS_APK_PATH} to Device Farm"
APP_UPLOAD_INFO=$(aws devicefarm create-upload \
  --project-arn "${AWS_PROJECT_ARN}" \
  --name "$(basename "${AWS_APK_PATH}")" \
  --type "${AWS_APP_TYPE}")
APP_UPLOAD_ARN=$(echo "${APP_UPLOAD_INFO}" | jq -r '.upload.arn')
upload_package "${AWS_APK_PATH}" "${APP_UPLOAD_INFO}"

# Upload Your Test Scripts Package
echo "Upload ${AWS_TEST_APK_PATH} to Device Farm"
TEST_UPLOAD_INFO=$(aws devicefarm create-upload \
  --project-arn "${AWS_PROJECT_ARN}" \
  --name "$(basename "${AWS_TEST_APK_PATH}")" \
  --type "${AWS_TEST_PACKAGE_TYPE}")
TEST_UPLOAD_ARN=$(echo "${TEST_UPLOAD_INFO}" | jq -r '.upload.arn')
upload_package "${AWS_TEST_APK_PATH}" "${TEST_UPLOAD_INFO}"

# Schedule a Test Run
echo "Schedule test run for uploaded app and tests package"
SCHEDULED_TEST_RUN_INFO=$(aws devicefarm schedule-run \
  --project-arn "${AWS_PROJECT_ARN}" \
  --app-arn "${APP_UPLOAD_ARN}" \
  --device-pool-arn "${AWS_DEVICE_POOL_ARN}" \
  --name "CM test run for build" \
  --test type=${AWS_TEST_TYPE},testPackageArn="${TEST_UPLOAD_ARN}")

wait_for_test_results "${SCHEDULED_TEST_RUN_INFO}"

echo "using Unity:"
echo $UNITY_HOME

APP_TYPE=$1

if [ ! -d "$UNITY_HOME" ]; then
  # Control will enter here if $DIRECTORY exists.
  echo "UNITY_HOME is not defined, please define UNITY_HOME env var where Unity app is located"
  exit 1;
fi

UNITY_BIN=./Unity

if [ "$(uname)" == "Darwin" ]; then
  echo "Runing under Mac OS X platform";
  UNITY_BIN="$UNITY_HOME/Contents/MacOS/Unity";
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  echo "Runing under GNU/Linux platform";
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  echo "Runing under 32 bits Windows NT platform";
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  echo "Runing under 64 bits Windows NT platform";
fi

if [ -f "$UNITY_BIN" ]; then
  echo "Building using bin $UNITY_BIN"
else
  echo "Error: $UNITY_BIN does not exist"
  exit 1;
fi

UNITY_PROJECT_PATH="./"
UNITY_LOG_FILE_IOS="$UNITY_PROJECT_PATH/Logs/unity_build_ios.log"
UNITY_LOG_FILE_ANDROID="$UNITY_PROJECT_PATH/Logs/unity_build_android.log"
UNITY_LOG_FILE="$UNITY_PROJECT_PATH/Logs/unity_build.log"

echo "UNITY_PROJECT_PATH=$UNITY_PROJECT_PATH"
echo "UNITY_LOG_FILE_IOS=$UNITY_LOG_FILE_IOS"
echo "UNITY_LOG_FILE_ANDROID=$UNITY_LOG_FILE_ANDROID"

# Begin script in case all parameters are correct
echo "UNITY LICENSE START"
$UNITY_BIN -quit -batchmode -logFile -skipBundles -serial $UNITY_SERIAL -username $UNITY_USERNAME -password $UNITY_PASSWORD
echo "UNITY LICENSE END"

if [ $APP_TYPE = "ios" ]
then
  echo "UNITY BUILD IOS START"
  $UNITY_BIN -quit -batchmode -projectPath $UNITY_PROJECT_PATH -executeMethod BuildScript.BuildXcode -nographics -logfile $UNITY_LOG_FILE_IOS
  echo "UNITY BUILD IOS END"
fi

if [ $APP_TYPE = "android" ]
then
  echo "UNITY BUILD ANDROID START"
  $UNITY_BIN -quit -batchmode -projectPath $UNITY_PROJECT_PATH -executeMethod BuildScript.BuildAndroid -nographics -logfile $UNITY_LOG_FILE_ANDROID
  "UNITY BUILD ANDROID END"
fi

echo "UNITY RETURN LICENSE START"
$UNITY_BIN -quit -batchmode -returnlicense -nographics
echo "UNITY RETURN LICENSE END"

if [ $? -eq 0 ]; then
  echo "Unity Build Complete"
else
  echo "Unity Build Failed"
  exit 1;
fi
sleep 1

echo "Done everything"

exit 0
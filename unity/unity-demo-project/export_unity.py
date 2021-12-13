import os
import platform
import sys

# Check if the app type argument has been provided e.g python3 export_unity.py windows | ios | android
if len(sys.argv) >= 2:
    APP_TYPE = sys.argv[1].lower()
    print(f'APP_TYPE set to: {APP_TYPE}')
else:
    print('APP_TYPE not set. End process.')
    sys.exit()

# Check environment variables have been set
vars = {'UNITY_HOME' : None, 'UNITY_SERIAL': None, 'UNITY_USERNAME' : None, 'UNITY_PASSWORD': None}
for key,value in vars.items():
    if key in os.environ:
        vars[key] = os.getenv(key)
    else:
        print(f'{key} is not set. End process.')
        sys.exit()   

# Set location of Unity binary according to machine type
platform = platform.system()
if platform == 'Darwin':
    UNITY_BIN = vars['UNITY_HOME'] + '/Contents/MacOS/Unity' 
    LOG_DIR = '/Logs/'
elif platform == 'Windows':
    UNITY_BIN = vars['UNITY_HOME'] + '\\Unity.exe'
    LOG_DIR = '\\Logs\\'
elif platform == "Linux":
    print("Build for Linux on Mac or Windows. End Process.")
    sys.exit()

# Check UNITY_BIN has been set
if UNITY_BIN is not None:
    print('UNITY_BIN set to: ' + UNITY_BIN)
else:
    print('UNITY_BIN does not exist. End process.')
    sys.exit()

# Set log file locations
UNITY_PROJECT_PATH = os.getcwd()
LOG_PATH = f'{UNITY_PROJECT_PATH}{LOG_DIR}'
UNITY_LOG_FILE_PLATFORM = f'{LOG_PATH}unity_build_{APP_TYPE}.log'
UNITY_LOG_FILE_LICENSE = f'{LOG_PATH}unity_license.log'

def buildPlatform(appType, unityBin, projectPath, logPath):
    print(f'UNITY START BUILDING {appType}')
    os.system(f'"{unityBin}" -quit -batchmode -projectPath {projectPath} -executeMethod BuildScript.Build{appType.capitalize()} -nographics -logFile {logPath}')
    print(f'UNITY END BUILDING {appType}')

def activateLicense(unityBin, logPath, unitySerial, unityUsername, unityPassword):
    print('UNITY LICENSE START')
    os.system(f'"{unityBin}" -quit -batchmode -skipBundles -logFile {logPath} -serial {unitySerial} -username {unityUsername} -password {unityPassword}')
    print('UNITY LICENSE END')

def returnLicense(unityBin):
    print('UNITY RETURN LICENSE START')
    os.system(f'"{unityBin}" -quit -batchmode -returnlicense -nographics')
    print('UNITY RETURN LICENSE END')


activateLicense(UNITY_BIN, UNITY_LOG_FILE_LICENSE, vars["UNITY_SERIAL"],vars["UNITY_USERNAME"],vars["UNITY_PASSWORD"])
buildPlatform(APP_TYPE.upper(), UNITY_BIN, UNITY_PROJECT_PATH, UNITY_LOG_FILE_PLATFORM)
returnLicense(UNITY_BIN)

print('UNITY BUILDING DONE')
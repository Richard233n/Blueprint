@echo off
cd "%~dp0"

::����
set WARNING_TEST_DIR=0

::debug info
set LOG_PATH=.\update.log
dir>%LOG_PATH%
echo ---->>%LOG_PATH%

::test dir
cd ..
cd ..
if not exist "Blueprint" (
set WARNING_TEST_DIR=1
echo %date% %time% Warning: Abnormal installation path>>%LOG_PATH%
echo ���棺���ƺ���װ���˴����·��������ܵ����ļ�Ȩ���쳣
)
cd "%~dp0"

::find git.exe
if exist ".\MinGit\cmd\git.exe" (
set GIT_PATH=.\MinGit\cmd\git.exe
echo %date% %time% Infomation: GIT_PATH=.\MinGit\cmd\git.exe>>%LOG_PATH%
) else (
set GIT_PATH=git
echo %date% %time% Infomation: GIT_PATH=git>>%LOG_PATH%
)

::test git.exe
%GIT_PATH% -v
if %errorlevel% NEQ 0 (
echo �����޷��ҵ�git.exe
echo %date% %time% Error: git.exe no found>>%LOG_PATH%
goto end_with_error
)

::find .git/
if not exist ".git" (
echo �����޷��ҵ�.git/
echo %date% %time% Error: .git/ no found>>%LOG_PATH%
goto end_with_error
)

::test .git/
%GIT_PATH% rev-parse --path-format=absolute --git-dir
if %errorlevel% NEQ 0 (
if %WARNING_TEST_DIR% NEQ 0 (
echo �����ļ�Ȩ���쳣����ͨ������Ϊgit��Ȩ��д������ͼ�ļ��С�
echo ���ڽ�ѹ��ͼ�ֿ����ͬ������ļ���һ����룬�����ǽ�ѹ�����е��ļ�ֱ�ӽ�ѹ����ͼ�ļ��С�
echo %date% %time% Error: .git/ is broken>>%LOG_PATH%
goto end_with_error
)
echo ����.git/����
echo %date% %time% Error: .git/ is broken>>%LOG_PATH%
goto end_with_error
)

::config
%GIT_PATH% config --local core.quotepath false
%GIT_PATH% config --local http.sslVerify false

::init
if not exist ".\.gitignore" (
%GIT_PATH% reset --hard
echo %date% %time% Infomation: %GIT_PATH% reset --hard>>%LOG_PATH%
)

::update
%GIT_PATH% pull origin main
if %errorlevel% NEQ 0 (
echo ���󣺸��»�ȡʧ�ܡ���ͨ�������粨�������Ծ��У���Ч��ʹ�ü�����/�����Ӻ��ٸ��¡�
echo %date% %time% Error: %GIT_PATH% pull origin main>>%LOG_PATH%
goto end_with_error
) else (
echo %date% %time% Infomation: %GIT_PATH% pull origin main>>%LOG_PATH%
)

:end
echo ��ͼ�ļ�������ɣ����ڿ���ֱ�ӹرմ˴���
echo %date% %time% Infomation: Exit>>%LOG_PATH%
pause
exit

:end_with_error
echo ������Ϊ���ִ������ֹ����ͼ�ļ�û�з����κα䶯
echo �����������Ķ�˵��https://github.com/DSPBluePrints/FactoryBluePrints/blob/main/README.md
echo �����Ȼ���ɿ��Լ�qqȺ������936739864���븽�ϴ�ҳ���ͼ��update.log��ͼ��
echo %date% %time% Infomation: Exit>>%LOG_PATH%
pause
exit

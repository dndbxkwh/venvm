# venvm (venv manager)
- 사용 방법 : 해당 배치 파일을 다운로드 후 스크립트의 디렉토리를 PATH 에 등록후 venvm 을 입력하여 사용할 수 있습니다.
- 파이썬의 기본 모듈인 venv 를 사용하기 편하게 만든 스크립트 입니다.
- 요구 사항 : Windows CMD 환경

## 주요 기능

### ■ 프로젝트 초기 세팅
- .venv 경로가 없다면 venv 초기 세팅을 진행합니다. (-v {VAR} 옵션으로 버전을 지정할 수 있습니다.)
- requirements.txt, .env, .gitignore 파일이 없다면 생성합니다.
- 이후 git 초기 세팅을 진행합니다.

### ■ venv 토글
- .venv/Scripts/activate & deactivate 명령어 대신 venvm 을 이용하여 토글할 수 있습니다.
- activate 될때 requirements.txt 파일에 내용이 있다면 패키지를 설치합니다.
- activate 될때 .env 파일의 환경변수를 등록하며, deactivate 될때 추가되었던 환경변수를 제거합니다. (세션에서만 유지됩니다.)


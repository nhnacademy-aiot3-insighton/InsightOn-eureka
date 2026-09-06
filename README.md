# insighton-eureka

InsightOn 서비스들을 위한 **Netflix Eureka 서버**(`@EnableEurekaServer`). 서비스 디스커버리가
필요했던 초기 **Docker Compose 기반 인프라** 구축 단계에서 도입된 프로젝트입니다.

## 상태 참고

현재 워크스페이스의 각 서비스(`InsightOn-core` 등)는 Eureka 클라이언트로 등록하지 않고,
Kubernetes DNS + `spring-cloud-starter-loadbalancer`(클라이언트 사이드 LB) 기반으로 서로를 호출합니다
(`pom.xml`에 `spring-cloud-starter-netflix-eureka-client` 의존성을 가진 서비스가 워크스페이스 내에
없음). 즉 k8s 전환 이후로는 실제로 참조되는 서비스는 없습니다.

## 설정

`src/main/resources/application.properties`:
- `server.port=8761`
- `eureka.client.register-with-eureka=false`, `eureka.client.fetch-registry=false` — 자기 자신은
  클라이언트로 등록하지 않는 순수 서버 전용 설정
- `eureka.server.enable-self-preservation=false` — 다수의 테스트/임시 클러스터 환경에서 인스턴스가
  자주 떴다 내려가며 self-preservation 모드가 오작동하는 것을 막기 위해 비활성화
- `management.endpoints.web.exposure.include=health`

## 실행

```bash
./mvnw spring-boot:run
```

기동 후 `http://localhost:8761`에서 Eureka 대시보드 확인 가능.

## 배포

`.github/workflows/deploy.yml`이 `InsightOn-infra` 저장소의 재사용 워크플로
(`eureka-ci-cd.yml`)를 호출해 CI/CD를 수행합니다 (`main`/`dev`/`dev-deploy` 브랜치).

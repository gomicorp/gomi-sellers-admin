# GomiSellersAdmin
고미 셀러즈 앱의 어드민입니다. 셀러 정보 및 판매 현황을 관리하고 정산할 수 있습니다.

## 환경
`.key` 파일은 `@bran` 에게 문의해주세요.

ENV | Credential (config/) | Key (config/) 
--- | --- | ---
production | credentials.yml.enc | master.key
development | credentials/development.yml.enc | credentials/development.key
staging | credentials/staging.yml.enc | credentials/staging.key

## 데이터베이스
EcommerceAPI ([github](https://github.com/gomicorp/EcommerceAPI)) 가 마이그레이션 하는 store_env_database 를 연결하며 데이터베이스와 직접 통신합니다.

### 스키마 편집 권한 없음
이 애플리케이션은 서비스 제품으로서, 스키마 편집을 수행할 권한이 없습니다.  
그래서 이 애플리케이션에는 `migration` 파일을 두지 않습니다.

#### Aliased rake
데이터베이스의 주요 변경을 적용받으려면 `rails db:migrate` 대신에 `rails db:schema:dump` 를 이용해야 했습니다.

하지만 언젠가 발생 할 수 있다는 가능성에 비해 그 위험성이 너무 큽니다.  
이 때문에 `rails db:migrate` 메소드와 `rails db:schema:load` 메소드의 기본 동작을 `rails db:schema:dump` 로 동작하도록 재정의 했습니다.

```
# 치명적으로 위험한 두 개의 Task 를 재정의 

$ rails db:migrate        # rails db:schema:dump 로 동작 
$ rails db:schema:load    # rails db:schema:dump 로 동작
```

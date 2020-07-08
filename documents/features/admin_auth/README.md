# 관리자 로그인 기능

- 가장 빠른 개발을 위해 Basic Auth 를 사용합니다.
- [고미스토어](https://github.com/gomicorp/GomiStore) 의 백오피스를 레퍼런스로 활용해서 코드를 재활용합니다.

## 내용

### a. Scope Out
#### 회원가입/비밀번호찾기/회원탈퇴 기능 생략
관리자 계정 인증만 가능하다면, 작업 시간 단축을 위해 로그인을 위해 별도의 관리자 회원가입 등 여벌의 절차는 생략합니다.
~~추후 고미 회원 인증 시스템을 통해 리펙토링하도록 합니다.~~


### b. 인증 컨트롤러
**기본적으로 모든 관리자 행동(Action)에 적용됩니다:**
```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base
  ...
  before_action :admin_auth 
    OR
  include AdminAuth
  ...
end
```

**구체적인 Action 에서 경우에 따라 생략이 가능합니다:**
```ruby
# app/controllers/foo_controller.rb

class FooController < ApplicationController
  skip_before_action :admin_auth, on: :show
end
```

### c. 관리자 모델
관리자 계정은 고미스토어의 일반 관리자 계정을 그대로 사용합니다.  
고미스토어와 동일하게, 개념도는 아래와 같습니다.
```ruby
# app/models/user.rb

class User < ApplicationRecord
  ...
end


# app/models/admin.rb

class Admin < User
  default_scope { where(is_admin: true) }
end
```

### e. `current_user` 헬퍼 메소드 지원
모든 Action 및 연결된 View 에서 `current_user` 헬퍼 메소드를 사용할 수 있습니다.

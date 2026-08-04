# Contact 웹사이트

GitHub에 아래 파일을 모두 업로드하세요.

- `index.html`
- `style.css`
- `script.js`
- `supabase-schema.sql` (실제 회원·글·메시지 저장용 데이터베이스 설계)

## 현재 프로토타입

`index.html`을 열면 바로 작동합니다. 현재 계정, 글, 메시지는 같은 브라우저의 저장 공간에 보관됩니다.

## 실제 사용자 데이터 저장

1. [Supabase](https://supabase.com/)에서 프로젝트를 만듭니다.
2. SQL Editor에서 `supabase-schema.sql` 전체를 실행합니다.
3. Supabase Auth에서 이메일/비밀번호 로그인을 켭니다.
4. `script.js`의 브라우저 저장 방식은 Supabase Auth와 데이터베이스 호출 방식으로 교체합니다.

비밀번호는 직접 테이블에 저장하면 안 됩니다. Supabase Auth가 암호화와 로그인 처리를 맡습니다.

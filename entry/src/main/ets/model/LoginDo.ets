export class RegisterModel{
  account:string
  password:string
  key:string
  code:string

  constructor(account: string, password: string, key: string, code: string) {
    this.account = account
    this.password = password
    this.key = key
    this.code = code
  }

}
export class LoginModel{
  account:string
  password:string

  constructor(account: string, password: string) {
    this.account = account
    this.password = password
  }

}
import { IsEmail, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @IsEmail()
  email;

  @IsString()
  @MinLength(6)
  password;
}

export class LoginDto {
  @IsEmail()
  email;

  @IsString()
  password;
}

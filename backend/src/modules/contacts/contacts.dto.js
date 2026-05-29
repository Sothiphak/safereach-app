import { IsOptional, IsString } from 'class-validator';

export class CreateContactDto {
  @IsString()
  name;

  @IsString()
  phone;

  @IsString()
  relationship;
}

export class UpdateContactDto {
  @IsOptional()
  @IsString()
  name;

  @IsOptional()
  @IsString()
  phone;

  @IsOptional()
  @IsString()
  relationship;
}

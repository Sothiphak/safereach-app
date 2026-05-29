import { IsIn, IsNumber, IsOptional, IsString } from 'class-validator';

import { SERVICE_TYPES } from '../../common/constants/service-types';

export class CreateBranchDto {
  @IsString()
  name;

  @IsIn(SERVICE_TYPES)
  type;

  @IsString()
  phone;

  @IsString()
  address;

  @IsNumber()
  latitude;

  @IsNumber()
  longitude;
}

export class UpdateBranchDto {
  @IsOptional()
  @IsString()
  name;

  @IsOptional()
  @IsIn(SERVICE_TYPES)
  type;

  @IsOptional()
  @IsString()
  phone;

  @IsOptional()
  @IsString()
  address;

  @IsOptional()
  @IsNumber()
  latitude;

  @IsOptional()
  @IsNumber()
  longitude;
}

export class BranchQueryDto {
  @IsOptional()
  @IsIn(SERVICE_TYPES)
  type;
}

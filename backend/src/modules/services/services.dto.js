import {
  ArrayNotEmpty,
  IsArray,
  IsBoolean,
  IsIn,
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  Min,
} from 'class-validator';

import { SERVICE_TYPES } from '../../common/constants/service-types';

export class CreateServiceDto {
  @IsString()
  name;

  @IsIn(SERVICE_TYPES)
  type;

  @IsString()
  phone;

  @IsString()
  address;

  @IsString()
  hours;

  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  services;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  rating;

  @IsOptional()
  @IsNumber()
  @Min(0)
  reviewCount;

  @IsNumber()
  @Min(0)
  distanceKm;

  @IsBoolean()
  openNow;

  @IsNumber()
  latitude;

  @IsNumber()
  longitude;

  @IsUrl()
  imageUrl;

  @IsString()
  description;
}

export class UpdateServiceDto {
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
  @IsString()
  hours;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  services;

  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  rating;

  @IsOptional()
  @IsNumber()
  @Min(0)
  reviewCount;

  @IsOptional()
  @IsNumber()
  @Min(0)
  distanceKm;

  @IsOptional()
  @IsBoolean()
  openNow;

  @IsOptional()
  @IsNumber()
  latitude;

  @IsOptional()
  @IsNumber()
  longitude;

  @IsOptional()
  @IsUrl()
  imageUrl;

  @IsOptional()
  @IsString()
  description;
}

export class ServiceQueryDto {
  @IsOptional()
  @IsIn(SERVICE_TYPES)
  type;

  @IsOptional()
  @IsBoolean()
  openNow;

  @IsOptional()
  @IsNumber()
  @Min(0)
  minRating;

  @IsOptional()
  @IsNumber()
  @Min(0)
  maxDistance;

  @IsOptional()
  @IsString()
  search;
}

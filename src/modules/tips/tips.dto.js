import { ArrayNotEmpty, IsArray, IsString } from 'class-validator';

export class CreateTipDto {
  @IsString()
  id;

  @IsString()
  title;

  @IsString()
  summary;

  @IsString()
  imageAsset;

  @IsArray()
  @ArrayNotEmpty()
  @IsString({ each: true })
  steps;
}

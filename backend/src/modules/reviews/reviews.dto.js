import { IsNumber, IsString, Max, Min } from 'class-validator';

export class CreateReviewDto {
  @IsString()
  serviceId;

  @IsString()
  author;

  @IsNumber()
  @Min(1)
  @Max(5)
  rating;

  @IsString()
  comment;
}

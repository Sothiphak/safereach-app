import { Body, Controller, Get, Post, Query } from '@nestjs/common';

import { buildValidationPipe } from '../../common/pipes/dto-validation.pipe';
import { CreateReviewDto } from './reviews.dto';
import { ReviewsService } from './reviews.service';

@Controller('reviews')
export class ReviewsController {
  constructor(reviewsService) {
    this.reviewsService = reviewsService;
  }

  @Get()
  findAll(@Query('serviceId') serviceId) {
    return this.reviewsService.findAll(serviceId);
  }

  @Post()
  create(@Body(buildValidationPipe(CreateReviewDto)) payload) {
    return this.reviewsService.create(payload);
  }
}

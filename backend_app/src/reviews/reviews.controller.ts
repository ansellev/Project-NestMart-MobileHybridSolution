import {
  Controller,
  Post,
  Get,
  Param,
  Body,
} from '@nestjs/common';

import { ReviewsService } from './reviews.service';

@Controller('reviews')
export class ReviewsController {
  constructor(
    private readonly reviewsService: ReviewsService,
  ) {}

  @Post()
  createReview(
    @Body() body: any,
  ) {
    return this.reviewsService.createReview(
      body,
    );
  }

  @Get('product/:productId')
  getProductReviews(
    @Param('productId') productId: string,
  ) {
    return this.reviewsService.getProductReviews(
      Number(productId),
    );
  }
}

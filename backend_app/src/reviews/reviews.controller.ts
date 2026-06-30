import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Request,
  UseGuards,
} from '@nestjs/common';

import { ReviewsService } from './reviews.service';
import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

import { CreateReviewDto } from './dto/create-review.dto';
import { UpdateReviewDto } from './dto/update-review.dto';

@Controller('reviews')
export class ReviewsController {
  constructor(
    private readonly reviewsService: ReviewsService,
  ) {}

  @Get(':productId')
  getProductReviews(
    @Param('productId') productId: string,
  ) {
    return this.reviewsService.getProductReviews(
      Number(productId),
    );
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  createReview(
    @Request() req,
    @Body() dto: CreateReviewDto,
  ) {
    return this.reviewsService.createReview(
      req.user.id,
      dto,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  updateReview(
    @Request() req,
    @Param('id') id: string,
    @Body() dto: UpdateReviewDto,
  ) {
    return this.reviewsService.updateReview(
      req.user.id,
      Number(id),
      dto,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  deleteReview(
    @Request() req,
    @Param('id') id: string,
  ) {
    return this.reviewsService.deleteReview(
      req.user.id,
      Number(id),
    );
  }
}
import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Review } from './review.entity';
import { Product } from '../products/product.entity';

import { CreateReviewDto } from './dto/create-review.dto';
import { UpdateReviewDto } from './dto/update-review.dto';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private readonly reviewRepository: Repository<Review>,

    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async getProductReviews(productId: number) {
    return {
      success: true,
      data: await this.reviewRepository.find({
        where: {
          productId,
        },
        order: {
          createdAt: 'DESC',
        },
      }),
    };
  }

  async createReview(
    userId: number,
    dto: CreateReviewDto,
  ) {
    const product = await this.productRepository.findOne({
      where: {
        id: dto.productId,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    const exists = await this.reviewRepository.findOne({
      where: {
        userId,
        productId: dto.productId,
      },
    });

    if (exists) {
      throw new BadRequestException(
        'You have already reviewed this product',
      );
    }

    const review = this.reviewRepository.create({
      userId,
      productId: dto.productId,
      rating: dto.rating,
      comment: dto.comment,
    });

    return {
      success: true,
      message: 'Review added successfully',
      data: await this.reviewRepository.save(review),
    };
  }

  async updateReview(
    userId: number,
    reviewId: number,
    dto: UpdateReviewDto,
  ) {
    const review = await this.reviewRepository.findOne({
      where: {
        id: reviewId,
        userId,
      },
    });

    if (!review) {
      throw new NotFoundException(
        'Review not found',
      );
    }

    Object.assign(review, dto);

    return {
      success: true,
      message: 'Review updated successfully',
      data: await this.reviewRepository.save(review),
    };
  }

  async deleteReview(
    userId: number,
    reviewId: number,
  ) {
    const review = await this.reviewRepository.findOne({
      where: {
        id: reviewId,
        userId,
      },
    });

    if (!review) {
      throw new NotFoundException(
        'Review not found',
      );
    }

    await this.reviewRepository.remove(review);

    return {
      success: true,
      message: 'Review deleted successfully',
    };
  }
}
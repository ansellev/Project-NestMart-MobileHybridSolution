import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Review } from './review.entity';

@Injectable()
export class ReviewsService {
  constructor(
    @InjectRepository(Review)
    private reviewRepository: Repository<Review>,
  ) {}

  async createReview(body: any) {
    const review =
      this.reviewRepository.create(body);

    return await this.reviewRepository.save(
      review,
    );
  }

  async getProductReviews(
    productId: number,
  ) {
    return await this.reviewRepository.find({
      where: {
        productId,
      },
      order: {
        createdAt: 'DESC',
      },
    });
  }
}

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Favorite } from './favorite.entity';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectRepository(Favorite)
    private favoriteRepository: Repository<Favorite>,
  ) {}

  async addFavorite(body: any) {
    const existing =
      await this.favoriteRepository.findOne({
        where: {
          userId: body.userId,
          productId: body.productId,
        },
      });

    if (existing) {
      return {
        success: false,
        message: 'Already in favorites',
      };
    }

    const favorite =
      this.favoriteRepository.create(body);

    return await this.favoriteRepository.save(
      favorite,
    );
  }

  async getFavorites(userId: number) {
    return await this.favoriteRepository.find({
      where: {
        userId,
      },
    });
  }

  async deleteFavorite(id: number) {
    return await this.favoriteRepository.delete(
      id,
    );
  }
}

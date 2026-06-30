import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Favorite } from './favorite.entity';
import { Product } from '../products/product.entity';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectRepository(Favorite)
    private readonly favoriteRepository: Repository<Favorite>,

    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async getMyFavorites(userId: number) {
    const favorites = await this.favoriteRepository.find({
      where: {
        userId,
      },
      order: {
        createdAt: 'DESC',
      },
    });

    const result: any[] = [];

    for (const favorite of favorites) {
      const product = await this.productRepository.findOne({
        where: {
          id: favorite.productId,
          isActive: true,
        },
      });

      if (!product) continue;

      result.push({
        favoriteId: favorite.id,
        productId: product.id,
        sellerId: product.sellerId,
        storeId: product.storeId,
        name: product.name,
        description: product.description,
        image: product.image,
        category: product.category,
        price: Number(product.price),
        stock: product.stock,
      });
    }

    return {
      success: true,
      total: result.length,
      data: result,
    };
  }

  async addFavorite(
    userId: number,
    productId: number,
  ) {
    const product = await this.productRepository.findOne({
      where: {
        id: productId,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    const exists = await this.favoriteRepository.findOne({
      where: {
        userId,
        productId,
      },
    });

    if (exists) {
      throw new BadRequestException(
        'Already in favorites',
      );
    }

    const favorite = this.favoriteRepository.create({
      userId,
      productId,
    });

    return {
      success: true,
      message: 'Added to favorites',
      data: await this.favoriteRepository.save(favorite),
    };
  }

  async removeFavorite(
    userId: number,
    productId: number,
  ) {
    const favorite = await this.favoriteRepository.findOne({
      where: {
        userId,
        productId,
      },
    });

    if (!favorite) {
      throw new NotFoundException(
        'Favorite not found',
      );
    }

    await this.favoriteRepository.remove(favorite);

    return {
      success: true,
      message: 'Removed from favorites',
    };
  }
}
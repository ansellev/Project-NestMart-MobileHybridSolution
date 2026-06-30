import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Favorite } from './favorite.entity';
import { Product } from '../products/product.entity';

import { FavoritesController } from './favorites.controller';
import { FavoritesService } from './favorites.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Favorite,
      Product,
    ]),
  ],
  controllers: [
    FavoritesController,
  ],
  providers: [
    FavoritesService,
  ],
  exports: [
    FavoritesService,
  ],
})
export class FavoritesModule {}
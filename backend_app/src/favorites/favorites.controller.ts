import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Request,
  UseGuards,
} from '@nestjs/common';

import { FavoritesService } from './favorites.service';
import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

@Controller('favorites')
@UseGuards(JwtAuthGuard)
export class FavoritesController {
  constructor(
    private readonly favoritesService: FavoritesService,
  ) {}

  @Get()
  getMyFavorites(
    @Request() req,
  ) {
    return this.favoritesService.getMyFavorites(
      req.user.id,
    );
  }

  @Post(':productId')
  addFavorite(
    @Request() req,
    @Param('productId') productId: string,
  ) {
    return this.favoritesService.addFavorite(
      req.user.id,
      Number(productId),
    );
  }

  @Delete(':productId')
  removeFavorite(
    @Request() req,
    @Param('productId') productId: string,
  ) {
    return this.favoritesService.removeFavorite(
      req.user.id,
      Number(productId),
    );
  }
}
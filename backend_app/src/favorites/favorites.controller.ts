import {
  Controller,
  Post,
  Get,
  Delete,
  Param,
  Body,
} from '@nestjs/common';

import { FavoritesService } from './favorites.service';

@Controller('favorites')
export class FavoritesController {
  constructor(
    private readonly favoritesService: FavoritesService,
  ) {}

  @Post()
  addFavorite(
    @Body() body: any,
  ) {
    return this.favoritesService.addFavorite(
      body,
    );
  }

  @Get(':userId')
  getFavorites(
    @Param('userId') userId: string,
  ) {
    return this.favoritesService.getFavorites(
      Number(userId),
    );
  }

  @Delete(':id')
  deleteFavorite(
    @Param('id') id: string,
  ) {
    return this.favoritesService.deleteFavorite(
      Number(id),
    );
  }
}

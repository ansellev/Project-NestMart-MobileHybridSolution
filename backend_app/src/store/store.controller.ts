import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Request,
  UseGuards,
} from '@nestjs/common';

import { StoreService } from './store.service';
import { CreateStoreDto } from './dto/create-store.dto';
import { UpdateStoreDto } from './dto/update-store.dto';

import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

@Controller('store')
export class StoreController {
  constructor(
    private readonly storeService: StoreService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  createStore(
    @Request() req,
    @Body() dto: CreateStoreDto,
  ) {
    return this.storeService.create(
      req.user.id,
      dto,
    );
  }

  @Get()
  getAllStores() {
    return this.storeService.findAll();
  }

  @Get(':id')
  getStoreById(
    @Param('id') id: string,
  ) {
    return this.storeService.findOne(
      Number(id),
    );
  }

  @UseGuards(JwtAuthGuard)
  @Get('me/profile')
  getMyStore(
    @Request() req,
  ) {
    return this.storeService.findMyStore(
      req.user.id,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Put()
  updateStore(
    @Request() req,
    @Body() dto: UpdateStoreDto,
  ) {
    return this.storeService.update(
      req.user.id,
      dto,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete()
  deleteStore(
    @Request() req,
  ) {
    return this.storeService.remove(
      req.user.id,
    );
  }
}
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

import { CartService } from './cart.service';

import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

import { CreateCartDto } from './dto/create-cart.dto';
import { UpdateCartDto } from './dto/update-cart.dto';

@Controller('cart')
@UseGuards(JwtAuthGuard)
export class CartController {
  constructor(
    private readonly cartService: CartService,
  ) {}

  @Get()
  getMyCart(
    @Request() req,
  ) {
    return this.cartService.getMyCart(
      req.user.id,
    );
  }

  @Post()
  addToCart(
    @Request() req,
    @Body() dto: CreateCartDto,
  ) {
    return this.cartService.addToCart(
      req.user.id,
      dto,
    );
  }

  @Put(':id')
  updateCart(
    @Request() req,
    @Param('id') id: string,
    @Body() dto: UpdateCartDto,
  ) {
    return this.cartService.updateCart(
      req.user.id,
      Number(id),
      dto,
    );
  }

  @Delete(':id')
  removeCartItem(
    @Request() req,
    @Param('id') id: string,
  ) {
    return this.cartService.removeCartItem(
      req.user.id,
      Number(id),
    );
  }

  @Delete('clear/all')
  clearCart(
    @Request() req,
  ) {
    return this.cartService.clearCart(
      req.user.id,
    );
  }
}
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
} from '@nestjs/common';

import { CartService } from './cart.service';

@Controller('cart')
export class CartController {
  constructor(
    private readonly cartService: CartService,
  ) {}

  @Post()
  addToCart(@Body() body: any) {
    return this.cartService.addToCart(body);
  }

  @Get(':userId')
  getCart(
    @Param('userId') userId: string,
  ) {
    return this.cartService.getCart(
      Number(userId),
    );
  }

  @Put(':id')
  updateCart(
    @Param('id') id: string,
    @Body() body: any,
  ) {
    return this.cartService.updateCart(
      Number(id),
      body,
    );
  }

  @Delete(':id')
  deleteCart(
    @Param('id') id: string,
  ) {
    return this.cartService.deleteCart(
      Number(id),
    );
  }

  @Delete('clear/:userId')
  clearCart(
    @Param('userId') userId: string,
  ) {
    return this.cartService.clearCart(
      Number(userId),
    );
  }
}

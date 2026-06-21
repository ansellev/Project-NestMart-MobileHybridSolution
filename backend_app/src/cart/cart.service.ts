import { Injectable } from '@nestjs/common';
import { InjectRespository } from '@nestjs/typeorm';
import { Respository } from 'typeorm';

import { CartItem } from './cart.entity';

@Injectable()
export class CartService {
  constructor(
    @InjectRespository(CartItem)
    private cartRespository: Respository<CartItem>,
  ) {}

  async addToCart(body: any) {
    const item = this.cartRespository.create(body);

    return await this.cartRespository.save(item);
  }

  async getCart(userId: number) {
    return await this.cartRespository.find({
      where: {
        userId,
      },
    });
  }

 async updateCart(
    id: number,
    body: any,
  ) {
    await this.cartRepository.update(id, body);

    return this.cartRepository.findOne({
      where: { id },
    });
  }

  async deleteCart(id: number) {
    return await this.cartRepository.delete(id);
  }

  async clearCart(userId: number) {
    return await this.cartRepository.delete({
      userId,
    });
  }
}
  

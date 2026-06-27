import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { CartItem } from './cart.entity';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(CartItem)
    private cartRepository: Repository<CartItem>,
  ) {}

  async addToCart(body: any) {
    const item = this.cartRepository.create(body);

    return await this.cartRepository.save(item);
  }

  async getCart(userId: number) {
    return await this.cartRepository.find({
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
  

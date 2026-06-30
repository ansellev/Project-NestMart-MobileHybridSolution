import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { CartItem } from './cart.entity';
import { Product } from '../products/product.entity';

import { CreateCartDto } from './dto/create-cart.dto';
import { UpdateCartDto } from './dto/update-cart.dto';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(CartItem)
    private readonly cartRepository: Repository<CartItem>,

    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async getMyCart(userId: number) {
    const cartItems = await this.cartRepository.find({
      where: {
        userId,
      },
      order: {
        createdAt: 'DESC',
      },
    });

    const items: any[] = [];
    let total = 0;

    for (const cart of cartItems) {
      const product = await this.productRepository.findOne({
        where: {
          id: cart.productId,
          isActive: true,
        },
      });

      if (!product) {
        continue;
      }

      const subtotal =
        Number(product.price) * cart.quantity;

      total += subtotal;

      items.push({
        cartId: cart.id,
        productId: product.id,
        sellerId: product.sellerId,
        storeId: product.storeId,
        name: product.name,
        description: product.description,
        image: product.image,
        category: product.category,
        price: Number(product.price),
        quantity: cart.quantity,
        stock: product.stock,
        subtotal,
      });
    }

    return {
      success: true,
      totalItems: items.length,
      grandTotal: total,
      data: items,
    };
  }

  async addToCart(
    userId: number,
    dto: CreateCartDto,
  ) {
    const product = await this.productRepository.findOne({
      where: {
        id: dto.productId,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    if (product.stock < dto.quantity) {
      throw new BadRequestException(
        'Insufficient stock',
      );
    }

    const existing = await this.cartRepository.findOne({
      where: {
        userId,
        productId: dto.productId,
      },
    });

    if (existing) {
      existing.quantity += dto.quantity;

      if (existing.quantity > product.stock) {
        throw new BadRequestException(
          'Insufficient stock',
        );
      }

      await this.cartRepository.save(existing);

      return {
        success: true,
        message: 'Cart updated',
        data: existing,
      };
    }

    const cart = this.cartRepository.create({
      userId,
      productId: product.id,
      sellerId: product.sellerId,
      quantity: dto.quantity,
    });

    return {
      success: true,
      message: 'Added to cart',
      data: await this.cartRepository.save(cart),
    };
  }

  async updateCart(
    userId: number,
    cartId: number,
    dto: UpdateCartDto,
  ) {
    const cart = await this.cartRepository.findOne({
      where: {
        id: cartId,
        userId,
      },
    });

    if (!cart) {
      throw new NotFoundException(
        'Cart item not found',
      );
    }

    const product = await this.productRepository.findOne({
      where: {
        id: cart.productId,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    if (
      dto.quantity !== undefined &&
      dto.quantity > product.stock
    ) {
      throw new BadRequestException(
        'Insufficient stock',
      );
    }

    Object.assign(cart, dto);

    return {
      success: true,
      message: 'Cart updated successfully',
      data: await this.cartRepository.save(cart),
    };
  }

  async removeCartItem(
    userId: number,
    cartId: number,
  ) {
    const cart = await this.cartRepository.findOne({
      where: {
        id: cartId,
        userId,
      },
    });

    if (!cart) {
      throw new NotFoundException(
        'Cart item not found',
      );
    }

    await this.cartRepository.remove(cart);

    return {
      success: true,
      message: 'Item removed from cart',
    };
  }

  async clearCart(userId: number) {
    await this.cartRepository.delete({
      userId,
    });

    return {
      success: true,
      message: 'Cart cleared',
    };
  }
}
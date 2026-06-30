import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';

import { Order } from './order.entity';
import { OrderItem } from './order-item.entity';

import { CartItem } from '../cart/cart.entity';
import { Product } from '../products/product.entity';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private readonly orderRepository: Repository<Order>,

    @InjectRepository(OrderItem)
    private readonly orderItemRepository: Repository<OrderItem>,

    @InjectRepository(CartItem)
    private readonly cartRepository: Repository<CartItem>,

    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,

    private readonly dataSource: DataSource,
  ) {}

  async createOrder(
  userId: number,
  items: {
    productId: number;
    quantity: number;
  }[],
) {
  let total = 0;

  const orderItems: OrderItem[] = [];

  for (const item of items) {
    const product = await this.productRepository.findOne({
      where: {
        id: item.productId,
      },
    });

    if (!product)
      throw new NotFoundException(
        `Product ${item.productId} tidak ditemukan`,
      );

    if (product.stock < item.quantity) {
      throw new NotFoundException(
        `${product.name} stok tidak cukup`,
      );
    }

    total += Number(product.price) * item.quantity;

    orderItems.push(
      this.orderItemRepository.create({
        productId: product.id,
        quantity: item.quantity,
        price: Number(product.price),
      }),
    );

    product.stock -= item.quantity;
    product.sold += item.quantity;

    await this.productRepository.save(product);
  }

  const order = this.orderRepository.create({
    userId,
    total,
    status: 'BARU',
  });

  const savedOrder = await this.orderRepository.save(order);

  for (const item of orderItems) {
    item.orderId = savedOrder.id;
    await this.orderItemRepository.save(item);
  }

  return {
    message: 'Checkout berhasil',
    orderId: savedOrder.id,
  };
}

  async checkout(userId: number) {
    const cartItems = await this.cartRepository.find({
      where: {
        userId,
      },
    });

    if (cartItems.length === 0) {
      throw new BadRequestException(
        'Your cart is empty',
      );
    }

    return this.dataSource.transaction(async (manager) => {
      let total = 0;

      const order = manager.create(Order, {
        userId,
        total: 0,
        status: 'Paid',
      });

      const savedOrder = await manager.save(order);

      for (const cart of cartItems) {
        const product = await manager.findOne(Product, {
          where: {
            id: cart.productId,
            isActive: true,
          },
        });

        if (!product) {
          throw new NotFoundException(
            `Product ${cart.productId} not found`,
          );
        }

        if (product.stock < cart.quantity) {
          throw new BadRequestException(
            `${product.name} stock is insufficient`,
          );
        }

        product.stock -= cart.quantity;
        product.sold += cart.quantity;

        await manager.save(product);

        await manager.save(
          manager.create(OrderItem, {
            orderId: savedOrder.id,
            productId: product.id,
            quantity: cart.quantity,
            price: product.price,
          }),
        );

        total +=
          Number(product.price) * cart.quantity;
      }

      savedOrder.total = total;
      await manager.save(savedOrder);

      await manager.delete(CartItem, {
        userId,
      });

      return {
        success: true,
        message: 'Checkout successful',
        orderId: savedOrder.id,
        total,
      };
    });
  }

  async getMyOrders(userId: number) {
    return {
      success: true,
      data: await this.orderRepository.find({
        where: {
          userId,
        },
        order: {
          createdAt: 'DESC',
        },
      }),
    };
  }

  async getOrderDetail(
    orderId: number,
    userId: number,
  ) {
    const order = await this.orderRepository.findOne({
      where: {
        id: orderId,
        userId,
      },
    });

    if (!order) {
      throw new NotFoundException(
        'Order not found',
      );
    }

    const items = await this.orderItemRepository.find({
      where: {
        orderId,
      },
    });

    const result: any[] = [];

    for (const item of items) {
      const product = await this.productRepository.findOne({
        where: {
          id: item.productId,
        },
      });

      result.push({
        productId: item.productId,
        name: product?.name ?? '',
        image: product?.image ?? '',
        quantity: item.quantity,
        price: Number(item.price),
        subtotal:
          Number(item.price) * item.quantity,
      });
    }

    return {
      success: true,
      order,
      items: result,
    };
  }
}
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Order } from './order.entity';
import { OrderItem } from './order-item.entity';

@Injectable()
export class OrdersService {
  constructor(
    @InjectRepository(Order)
    private orderRepository: Repository<Order>,

    @InjectRepository(OrderItem)
    private orderItemRepository: Repository<OrderItem>,
  ) {}

  async createOrder(body: any) {
    const order = this.orderRepository.create({
      userId: body.userId,
      total: body.total,
      status: 'Paid',
    });

    const savedOrder =
      await this.orderRepository.save(order);

    if (body.items) {
      for (const item of body.items) {
        await this.orderItemRepository.save({
          orderId: savedOrder.id,
          productId: item.productId,
          quantity: item.quantity,
          price: item.price,
        });
      }
    }

    return {
      success: true,
      order: savedOrder,
    };
  }

  async getOrders(userId: number) {
    return await this.orderRepository.find({
      where: {
        userId,
      },
      order: {
        createdAt: 'DESC',
      },
    });
  }

  async getOrderDetail(id: number) {
    const order =
      await this.orderRepository.findOne({
        where: { id },
      });

    const items =
      await this.orderItemRepository.find({
        where: {
          orderId: id,
        },
      });

    return {
      order,
      items,
    };
  }
}

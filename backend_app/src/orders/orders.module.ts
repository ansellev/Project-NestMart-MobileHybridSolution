import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Order } from './order.entity';
import { OrderItem } from './order-item.entity';

import { CartItem } from '../cart/cart.entity';
import { Product } from '../products/product.entity';

import { OrdersController } from './orders.controller';
import { OrdersService } from './orders.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Order,
      OrderItem,
      CartItem,
      Product,
    ]),
  ],
  controllers: [
    OrdersController,
  ],
  providers: [
    OrdersService,
  ],
  exports: [
    OrdersService,
  ],
})
export class OrdersModule {}
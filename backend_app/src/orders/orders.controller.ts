import {
  Controller,
  Post,
  Get,
  Param,
  Body,
} from '@nestjs/common';

import { OrdersService } from './orders.service';

@Controller('orders')
export class OrdersController {
  constructor(
    private readonly ordersService: OrdersService,
  ) {}

  @Post()
  createOrder(
    @Body() body: any,
  ) {
    return this.ordersService.createOrder(
      body,
    );
  }

  @Get(':userId')
  getOrders(
    @Param('userId') userId: string,
  ) {
    return this.ordersService.getOrders(
      Number(userId),
    );
  }

  @Get('detail/:id')
  getOrderDetail(
    @Param('id') id: string,
  ) {
    return this.ordersService.getOrderDetail(
      Number(id),
    );
  }
}

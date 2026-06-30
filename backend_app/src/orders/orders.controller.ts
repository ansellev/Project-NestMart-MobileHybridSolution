import {
  Controller,
  Get,
  Post,
  Param,
  Request,
  UseGuards,
} from '@nestjs/common';

import { OrdersService } from './orders.service';
import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

@Controller('orders')
@UseGuards(JwtAuthGuard)
export class OrdersController {
  constructor(
    private readonly ordersService: OrdersService,
  ) {}

  @Post('checkout')
  checkout(
    @Request() req,
  ) {
    return this.ordersService.checkout(
      req.user.id,
    );
  }

  @Get('my')
  getMyOrders(
    @Request() req,
  ) {
    return this.ordersService.getMyOrders(
      req.user.id,
    );
  }

  @Get(':id')
  getOrderDetail(
    @Request() req,
    @Param('id') id: string,
  ) {
    return this.ordersService.getOrderDetail(
      Number(id),
      req.user.id,
    );
  }
}
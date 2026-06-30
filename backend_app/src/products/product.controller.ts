import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Request,
  UseGuards,
} from '@nestjs/common';

import { ProductService } from './product.service';

import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

import { JwtAuthGuard } from '../auth/jwt/jwt-auth.guard';

@Controller('products')
export class ProductsController {
  constructor(
    private readonly productService: ProductService,
  ) {}

  // ===========================
  // PUBLIC
  // ===========================

  @Get()
  getAllProducts() {
    return this.productService.getAllProducts();
  }

  @Get(':id')
  getProductById(
    @Param('id') id: string,
  ) {
    return this.productService.getProductById(
      Number(id),
    );
  }

  // ===========================
  // SELLER
  // ===========================

  @UseGuards(JwtAuthGuard)
  @Get('seller/me')
  getMyProducts(
    @Request() req,
  ) {
    return this.productService.getSellerProducts(
      req.user.id,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  createProduct(
    @Request() req,
    @Body() dto: CreateProductDto,
  ) {
    return this.productService.createProduct(
      req.user.id,
      dto,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Put(':id')
  updateProduct(
    @Request() req,
    @Param('id') id: string,
    @Body() dto: UpdateProductDto,
  ) {
    return this.productService.updateProduct(
      req.user.id,
      Number(id),
      dto,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  deleteProduct(
    @Request() req,
    @Param('id') id: string,
  ) {
    return this.productService.deleteProduct(
      req.user.id,
      Number(id),
    );
  }
}
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
} from '@nestjs/common';

import{ ProductsService } from './products.service';

@Controller('products')
  export class ProductsController {
  constructor(
    private readonly productsService: ProductsService,
) {}

@Get()
  getAllProducts() {
    return this.productsService.getAllProducts();
}

@Get(':id')
  getProductById(
    @Param('id') id: string,
) {
  return this.productsService.getProductById(
    Number(id),
  );
}

@Post()
  createProduct(
    @Body() body: any,
  ) {
    return this.productsService.createProduct(
      body,
    );
  }

@PutQ(':id')
  updateProduct(
    @Param('id') id: string,
    @body() body: any,
  ) {
    return this.porductsService.updateProduct(
      Number(id),
      body,
    );
  }

@Delete(':id')
  deleteProduct(
    @Param('id') id: string,
  ) {
    return this.productsService.deleteProduct(
      Number(id),
    );
  }
}

import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Product } from './product.entity';
import { Store } from '../store/store.entity';

import { ProductsController } from './product.controller';
import { ProductService } from './product.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      Store,
    ]),
  ],
  controllers: [
    ProductsController,
  ],
  providers: [
    ProductService,
  ],
  exports: [
    ProductService,
  ],
})
export class ProductsModule {}
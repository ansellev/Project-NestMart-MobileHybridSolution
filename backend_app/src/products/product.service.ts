import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Product } from './product.entity';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private productRepository: Repository<Product>,
  ) {}

  async getAllProducts() {
    return await this.productRepository.find();
  }

  async getProductById(id: number) {
    return await this.productRepository.findOne({
      where: { id },
    });
  }

  async createProduct(body: any) {
    const product =
      this.productRepository.create(body);

    return await this.productRepository.save(
      product,
    );
  }

  async updateProduct(
    id: number,
    body: any,
  ) {
    await this.productRepository.update(
      id,
      body,
    );

    return this.getProductById(id);
  }

  async deleteProduct(id: number) {
    return await this.productRepository.delete(
      id,
    );
  }
}

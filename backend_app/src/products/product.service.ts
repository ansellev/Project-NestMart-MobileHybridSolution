import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Product } from './product.entity';
import { Store } from '../store/store.entity';

import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,

    @InjectRepository(Store)
    private readonly storeRepository: Repository<Store>,
  ) {}

  async getAllProducts() {
    return {
      success: true,
      data: await this.productRepository.find({
        where: {
          isActive: true,
        },
        order: {
          createdAt: 'DESC',
        },
      }),
    };
  }

  async getProductById(id: number) {
    const product = await this.productRepository.findOne({
      where: {
        id,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return {
      success: true,
      data: product,
    };
  }

  async getSellerProducts(userId: number) {
    return {
      success: true,
      data: await this.productRepository.find({
        where: {
          sellerId: userId,
          isActive: true,
        },
        order: {
          createdAt: 'DESC',
        },
      }),
    };
  }

  async createProduct(
    userId: number,
    dto: CreateProductDto,
  ) {
    const store = await this.storeRepository.findOne({
      where: {
        ownerId: userId,
      },
    });

    if (!store) {
      throw new BadRequestException(
        'Please create a store first',
      );
    }

    const product = this.productRepository.create({
      sellerId: userId,
      storeId: store.id,
      name: dto.name,
      description: dto.description,
      price: dto.price,
      image: dto.image ?? '',
      category: dto.category ?? '',
      stock: dto.stock,
      sold: 0,
      isActive: true,
    });

    return {
      success: true,
      message: 'Product created successfully',
      data: await this.productRepository.save(product),
    };
  }

  async updateProduct(
    userId: number,
    productId: number,
    dto: UpdateProductDto,
  ) {
    const product = await this.productRepository.findOne({
      where: {
        id: productId,
        sellerId: userId,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    Object.assign(product, dto);

    return {
      success: true,
      message: 'Product updated successfully',
      data: await this.productRepository.save(product),
    };
  }

  async deleteProduct(
    userId: number,
    productId: number,
  ) {
    const product = await this.productRepository.findOne({
      where: {
        id: productId,
        sellerId: userId,
        isActive: true,
      },
    });

    if (!product) {
      throw new NotFoundException(
        'Product not found',
      );
    }

    product.isActive = false;

    await this.productRepository.save(product);

    return {
      success: true,
      message: 'Product deleted successfully',
    };
  }
}
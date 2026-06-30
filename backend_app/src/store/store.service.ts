import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { Store } from './store.entity';
import { User, UserRole } from '../auth/user.entity';

import { CreateStoreDto } from './dto/create-store.dto';
import { UpdateStoreDto } from './dto/update-store.dto';

@Injectable()
export class StoreService {
  constructor(
    @InjectRepository(Store)
    private readonly storeRepository: Repository<Store>,

    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(
    userId: number,
    dto: CreateStoreDto,
  ) {
    const user = await this.userRepository.findOne({
      where: {
        id: userId,
      },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const myStore = await this.storeRepository.findOne({
      where: {
        ownerId: userId,
      },
    });

    if (myStore) {
      throw new BadRequestException(
        'You already have a store',
      );
    }

    const duplicateStore = await this.storeRepository.findOne({
      where: {
        storeName: dto.storeName,
      },
    });

    if (duplicateStore) {
      throw new BadRequestException(
        'Store name already exists',
      );
    }

    const store = this.storeRepository.create({
      ownerId: userId,
      storeName: dto.storeName,
      description: dto.description ?? '',
      logo: dto.logo ?? '',
      address: dto.address ?? '',
    });

    const savedStore = await this.storeRepository.save(store);

    user.role = UserRole.SELLER;
    await this.userRepository.save(user);

    return {
      success: true,
      message: 'Store created successfully',
      data: savedStore,
    };
  }

  async findMyStore(userId: number) {
    const store = await this.storeRepository.findOne({
      where: {
        ownerId: userId,
      },
    });

    if (!store) {
      throw new NotFoundException(
        'Store not found',
      );
    }

    return {
      success: true,
      data: store,
    };
  }

  async findAll() {
    const stores = await this.storeRepository.find({
      order: {
        createdAt: 'DESC',
      },
    });

    return {
      success: true,
      total: stores.length,
      data: stores,
    };
  }

  async findOne(id: number) {
    const store = await this.storeRepository.findOne({
      where: {
        id,
      },
    });

    if (!store) {
      throw new NotFoundException(
        'Store not found',
      );
    }

    return {
      success: true,
      data: store,
    };
  }

  async update(
    userId: number,
    dto: UpdateStoreDto,
  ) {
    const store = await this.storeRepository.findOne({
      where: {
        ownerId: userId,
      },
    });

    if (!store) {
      throw new NotFoundException(
        'Store not found',
      );
    }

    if (
      dto.storeName &&
      dto.storeName !== store.storeName
    ) {
      const duplicate = await this.storeRepository.findOne({
        where: {
          storeName: dto.storeName,
        },
      });

      if (duplicate) {
        throw new BadRequestException(
          'Store name already exists',
        );
      }
    }

    Object.assign(store, dto);

    const updatedStore = await this.storeRepository.save(
      store,
    );

    return {
      success: true,
      message: 'Store updated successfully',
      data: updatedStore,
    };
  }

  async remove(userId: number) {
    const store = await this.storeRepository.findOne({
      where: {
        ownerId: userId,
      },
    });

    if (!store) {
      throw new NotFoundException(
        'Store not found',
      );
    }

    await this.storeRepository.remove(store);

    const user = await this.userRepository.findOne({
      where: {
        id: userId,
      },
    });

    if (user) {
      user.role = UserRole.BUYER;
      await this.userRepository.save(user);
    }

    return {
      success: true,
      message: 'Store deleted successfully',
    };
  }
}
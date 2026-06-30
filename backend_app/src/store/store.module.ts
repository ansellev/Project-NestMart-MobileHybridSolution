import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { Store } from './store.entity';
import { User } from '../auth/user.entity';

import { StoreController } from './store.controller';
import { StoreService } from './store.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Store,
      User,
    ]),
  ],
  controllers: [
    StoreController,
  ],
  providers: [
    StoreService,
  ],
  exports: [
    StoreService,
  ],
})
export class StoreModule {}
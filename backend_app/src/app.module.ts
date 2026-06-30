import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AuthModule } from './auth/auth.module';
import { ProductsModule } from './products/product.module';
import { CartModule } from './cart/cart.module';
import { OrdersModule } from './orders/orders.module';
import { FavoritesModule } from './favorites/favorites.module';
import { ReviewsModule } from './reviews/reviews.module';
import { StoreModule } from './store/store.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '',
      database: 'nestmart',
      autoLoadEntities: true,
      synchronize: true,
    }),

    AuthModule,
    ProductsModule,
    CartModule,
    OrdersModule,
    FavoritesModule,
    ReviewsModule,
    StoreModule,
    
  ],
})
export class AppModule {}

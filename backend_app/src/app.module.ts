import { AuthModule } from './auth/auth.module';
import { ProductsModule } from './products/products.module';
import { CartModule } from './cart/cart.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '',
      database: 'nestmart_db',
      autoLoadEntities: true,
      synchronize: true,
    }),

    AuthModule,
    ProductsModule,
    CartModule,
  ],
})
export class AppModule {}

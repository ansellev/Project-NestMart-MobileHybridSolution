import { AuthModule } from './auth/auth.module';

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
  ],
})
export class AppModule {}

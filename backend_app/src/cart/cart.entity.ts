import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
} from 'typeorm';

@entity('cart_items')
export class CartItem {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @column()
  productId: number;

  @column({
    default: 1,
  })
  quantity: number;
}

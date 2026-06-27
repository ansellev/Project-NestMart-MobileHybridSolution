import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
} from 'typeorm';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column('text')
  description: string;

  @Column('decimal')
  price: number;

  @Column()
  image: string;

  @Column()
  category: string;

  @Column()
  storeName: string;

  @Column({
    default: 0,
  })
  stock: number;
}

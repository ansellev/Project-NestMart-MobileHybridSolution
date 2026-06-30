import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({
    nullable: false,
  })
  sellerId: number;

  @Column({
    nullable: false,
  })
  storeId: number;

  @Column({
    length: 200,
  })
  name: string;

  @Column({
    type: 'text',
  })
  description: string;

  @Column({
    type: 'decimal',
    precision: 10,
    scale: 2,
  })
  price: number;

  @Column({
    default: '',
  })
  image: string;

  @Column({
    default: '',
  })
  category: string;

  @Column({
    default: 0,
  })
  stock: number;

  @Column({
    default: 0,
  })
  sold: number;

  @Column({
    default: true,
  })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
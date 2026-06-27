import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @Column('decimal')
  total: number;

  @Column({
    default: 'Paid',
  })
  status: string;

  @CreateDateColumn()
  createdAt: Date;
}

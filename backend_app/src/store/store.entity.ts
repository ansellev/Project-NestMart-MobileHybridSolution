import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('stores')
export class Store {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  ownerId: number;

  @Column({
    unique: true,
    length: 150,
  })
  storeName: string;

  @Column({
    type: 'text',
    nullable: true,
  })
  description: string;

  @Column({
    nullable: true,
  })
  logo: string;

  @Column({
    type: 'text',
    nullable: true,
  })
  address: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
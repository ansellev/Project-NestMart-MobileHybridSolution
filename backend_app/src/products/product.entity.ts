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

  @Column()
  stock: number;
}

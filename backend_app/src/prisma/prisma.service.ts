import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService implements OnModuleInit, OnModuleDestroy {
  private readonly _client = new PrismaClient();

  get user()      { return this._client.user; }
  get product()   { return this._client.product; }
  get cartItem()  { return this._client.cartItem; }
  get order()     { return this._client.order; }
  get orderItem() { return this._client.orderItem; }
  get favorite()  { return this._client.favorite; }
  get review()    { return this._client.review; }

  async onModuleInit()   { await this._client.$connect(); }
  async onModuleDestroy(){ await this._client.$disconnect(); }
  async $transaction<T>(
    fn: (tx: Omit<PrismaClient, '$connect'|'$disconnect'|'$on'|'$transaction'|'$use'|'$extends'>) => Promise<T>,
  ): Promise<T> {
    return this._client.$transaction(fn);
  }
}

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async register(body: any) {
    const existingUser =
      await this.userRepository.findOne({
        where: {
          email: body.email,
        },
      });

    if (existingUser) {
      return {
        success: false,
        message: 'Email already exists',
      };
    }

    const hashedPassword =
      await bcrypt.hash(body.password, 10);

    const user = this.userRepository.create({
      name: body.name,
      email: body.email,
      password: hashedPassword,
    });

    await this.userRepository.save(user);

    return {
      success: true,
      message: 'Register success',
    };
  }

  async login(body: any) {
    const user =
      await this.userRepository.findOne({
        where: {
          email: body.email,
        },
      });

    if (!user) {
      return {
        success: false,
        message: 'User not found',
      };
    }

    const validPassword =
      await bcrypt.compare(
        body.password,
        user.password,
      );

    if (!validPassword) {
      return {
        success: false,
        message: 'Wrong password',
      };
    }

    return {
      success: true,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    };
  }

  async getProfile(id: number) {
    const user =
      await this.userRepository.findOne({
        where: { id },
      });

    if (!user) {
      return {
        success: false,
      };
    }

    return {
      success: true,
      user,
    };
  }
}

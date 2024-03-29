import { NextFunction, Request, Response } from 'express';
import rateLimit, { MemoryStore, RateLimitRequestHandler } from 'express-rate-limit';
import Config from 'simple-app-config';
import logger from '../../../logging/logger';
import { API_URLS_V1_PREFIX, Environments, GenericResponseMessages } from '../../common/constants';
import RedisStore from 'rate-limit-redis';
import RedisClient from '../../../database/redis/redisClient';
import _ from 'lodash';

/* Get environment */
const environment = Config.get('ENV');

/**
 * Returns rate limiter for create user
 */
export function getRateLimitCreateUser() {
  let rateLimiterMiddleware: RateLimitRequestHandler | undefined = undefined;

  return function (req: Request, res: Response, next: NextFunction) {
    if (!rateLimiterMiddleware) {
      rateLimiterMiddleware = rateLimit({
        windowMs: Config.get('RATE_LIMITING.USERS.POST.WINDOW'),
        max: Config.get('RATE_LIMITING.USERS.POST.THRESHOLD'),
        handler: (req, res) => {
          logger.info(`The create user rate limit has been reached for IP ${req.ip}`);
          res.status(429).json({
            message: GenericResponseMessages._429
          });
        },
        store:
          /* istanbul ignore next */
          environment == Environments.Test
            ? new MemoryStore()
            : new RedisStore({
                sendCommand: /* istanbul ignore next */ (...args) =>
                  RedisClient.getClient().sendCommand(args)
              }),
        keyGenerator: (req) => {
          return `${req.method}-${_.trimStart(req.baseUrl, API_URLS_V1_PREFIX)}-${req.ip}`;
        }
      });
    }

    rateLimiterMiddleware(req, res, next);
  };
}

/**
 * Returns rate limiter for update user
 */
export function getRateLimitUpdateUser() {
  let rateLimiterMiddleware: RateLimitRequestHandler | undefined = undefined;

  return function (req: Request, res: Response, next: NextFunction) {
    if (!rateLimiterMiddleware) {
      rateLimiterMiddleware = rateLimit({
        windowMs: Config.get('RATE_LIMITING.USERS.PUT.WINDOW'),
        max: Config.get('RATE_LIMITING.USERS.PUT.THRESHOLD'),
        handler: (req, res) => {
          logger.info(`The update user rate limit has been reached for IP ${req.ip}`);
          res.status(429).json({
            message: GenericResponseMessages._429
          });
        },
        store:
          /* istanbul ignore next */
          environment == Environments.Test
            ? new MemoryStore()
            : new RedisStore({
                sendCommand: /* istanbul ignore next */ (...args) =>
                  RedisClient.getClient().sendCommand(args)
              }),
        keyGenerator: (req) => {
          return `${req.method}-${_.trimStart(req.baseUrl, API_URLS_V1_PREFIX)}/:id-${req.ip}`;
        }
      });
    }

    rateLimiterMiddleware(req, res, next);
  };
}

/**
 * Returns rate limiter for get user
 */
export function getRateLimitGetUser() {
  let rateLimiterMiddleware: RateLimitRequestHandler | undefined = undefined;

  return function (req: Request, res: Response, next: NextFunction) {
    if (!rateLimiterMiddleware) {
      rateLimiterMiddleware = rateLimit({
        windowMs: Config.get('RATE_LIMITING.USERS.GET.WINDOW'),
        max: Config.get('RATE_LIMITING.USERS.GET.THRESHOLD'),
        handler: (req, res) => {
          logger.info(`The get user rate limit has been reached for IP ${req.ip}`);
          res.status(429).json({
            message: GenericResponseMessages._429
          });
        },
        store:
          /* istanbul ignore next */
          environment == Environments.Test
            ? new MemoryStore()
            : new RedisStore({
                sendCommand: /* istanbul ignore next */ (...args) =>
                  RedisClient.getClient().sendCommand(args)
              }),
        keyGenerator: (req) => {
          return `${req.method}-${_.trimStart(req.baseUrl, API_URLS_V1_PREFIX)}/:id-${req.ip}`;
        }
      });
    }

    rateLimiterMiddleware(req, res, next);
  };
}

/**
 * Returns rate limiter for delete user
 */
export function getRateLimitDeleteUser() {
  let rateLimiterMiddleware: RateLimitRequestHandler | undefined = undefined;

  return function (req: Request, res: Response, next: NextFunction) {
    if (!rateLimiterMiddleware) {
      rateLimiterMiddleware = rateLimit({
        windowMs: Config.get('RATE_LIMITING.USERS.DELETE.WINDOW'),
        max: Config.get('RATE_LIMITING.USERS.DELETE.THRESHOLD'),
        handler: (req, res) => {
          logger.info(`The delete user rate limit has been reached for IP ${req.ip}`);
          res.status(429).json({
            message: GenericResponseMessages._429
          });
        },
        store:
          /* istanbul ignore next */
          environment == Environments.Test
            ? new MemoryStore()
            : new RedisStore({
                sendCommand: /* istanbul ignore next */ (...args) =>
                  RedisClient.getClient().sendCommand(args)
              }),
        keyGenerator: (req) => {
          return `${req.method}-${_.trimStart(req.baseUrl, API_URLS_V1_PREFIX)}/:id-${req.ip}`;
        }
      });
    }

    rateLimiterMiddleware(req, res, next);
  };
}
